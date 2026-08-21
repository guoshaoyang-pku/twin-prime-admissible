import Sound
import lean_certs.cert_6_12

open CertVerify

theorem H6_gt_12 : ¬ ∃ t : List Nat, admissible 6 t = true ∧ diameter t ≤ 12 := by
  exact certValidRoot_sound (k := 6) (d := 12) (c := cert_6_12) (by native_decide)
