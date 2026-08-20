import Sound
import lean_certs.cert_33_94

open CertVerify

theorem H33_gt_94 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 33) (d := 94) (c := cert_33_94) (by native_decide)
