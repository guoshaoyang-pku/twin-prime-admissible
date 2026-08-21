import Sound
import lean_certs.cert_7_14

open CertVerify

theorem H7_gt_14 : ¬ ∃ t : List Nat, admissible 7 t = true ∧ diameter t ≤ 14 := by
  exact certValidRoot_sound (k := 7) (d := 14) (c := cert_7_14) (by native_decide)
