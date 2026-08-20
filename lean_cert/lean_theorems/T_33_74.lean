import Sound
import lean_certs.cert_33_74

open CertVerify

theorem H33_gt_74 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 33) (d := 74) (c := cert_33_74) (by native_decide)
