import Sound
import lean_certs.cert_33_90

open CertVerify

theorem H33_gt_90 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 33) (d := 90) (c := cert_33_90) (by native_decide)
