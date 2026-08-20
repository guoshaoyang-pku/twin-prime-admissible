import Sound
import lean_certs.cert_33_92

open CertVerify

theorem H33_gt_92 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 33) (d := 92) (c := cert_33_92) (by native_decide)
