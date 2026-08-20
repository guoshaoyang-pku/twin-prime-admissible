import Sound
import lean_certs.cert_36_146

open CertVerify

theorem H36_gt_146 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 36) (d := 146) (c := cert_36_146) (by native_decide)
