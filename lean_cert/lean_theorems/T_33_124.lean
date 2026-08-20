import Sound
import lean_certs.cert_33_124

open CertVerify

theorem H33_gt_124 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 33) (d := 124) (c := cert_33_124) (by native_decide)
