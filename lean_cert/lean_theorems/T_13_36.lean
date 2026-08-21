import Sound
import lean_certs.cert_13_36

open CertVerify

theorem H13_gt_36 : ¬ ∃ t : List Nat, admissible 13 t = true ∧ diameter t ≤ 36 := by
  exact certValidRoot_sound (k := 13) (d := 36) (c := cert_13_36) (by native_decide)
