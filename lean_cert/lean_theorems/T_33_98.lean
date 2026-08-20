import Sound
import lean_certs.cert_33_98

open CertVerify

theorem H33_gt_98 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 33) (d := 98) (c := cert_33_98) (by native_decide)
