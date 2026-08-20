import Sound
import lean_certs.cert_33_70

open CertVerify

theorem H33_gt_70 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 70 := by
  exact certValidRoot_sound (k := 33) (d := 70) (c := cert_33_70) (by native_decide)
