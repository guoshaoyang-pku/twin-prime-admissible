import Sound
import lean_certs.cert_33_120

open CertVerify

theorem H33_gt_120 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 33) (d := 120) (c := cert_33_120) (by native_decide)
