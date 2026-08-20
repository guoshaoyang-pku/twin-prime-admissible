import Sound
import lean_certs.cert_33_140

open CertVerify

theorem H33_gt_140 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 33) (d := 140) (c := cert_33_140) (by native_decide)
