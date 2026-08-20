import Sound
import lean_certs.cert_33_146

open CertVerify

theorem H33_gt_146 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 33) (d := 146) (c := cert_33_146) (by native_decide)
