import Sound
import lean_certs.cert_7_12

open CertVerify

theorem H7_gt_12 : ¬ ∃ t : List Nat, admissible 7 t = true ∧ diameter t ≤ 12 := by
  exact certValidRoot_sound (k := 7) (d := 12) (c := cert_7_12) (by native_decide)
