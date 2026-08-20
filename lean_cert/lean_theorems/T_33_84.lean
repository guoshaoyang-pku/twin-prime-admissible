import Sound
import lean_certs.cert_33_84

open CertVerify

theorem H33_gt_84 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 33) (d := 84) (c := cert_33_84) (by native_decide)
