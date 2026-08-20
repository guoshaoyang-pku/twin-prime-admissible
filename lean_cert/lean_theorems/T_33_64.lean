import Sound
import lean_certs.cert_33_64

open CertVerify

theorem H33_gt_64 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 33) (d := 64) (c := cert_33_64) (by native_decide)
