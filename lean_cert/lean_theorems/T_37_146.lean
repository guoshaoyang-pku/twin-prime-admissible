import Sound
import lean_certs.cert_37_146

open CertVerify

theorem H37_gt_146 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 37) (d := 146) (c := cert_37_146) (by native_decide)
