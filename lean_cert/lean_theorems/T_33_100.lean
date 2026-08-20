import Sound
import lean_certs.cert_33_100

open CertVerify

theorem H33_gt_100 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 33) (d := 100) (c := cert_33_100) (by native_decide)
