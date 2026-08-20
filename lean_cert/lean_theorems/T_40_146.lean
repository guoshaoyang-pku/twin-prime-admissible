import Sound
import lean_certs.cert_40_146

open CertVerify

theorem H40_gt_146 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 40) (d := 146) (c := cert_40_146) (by native_decide)
