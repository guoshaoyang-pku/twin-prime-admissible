import Sound
import lean_certs.cert_42_112

open CertVerify

theorem H42_gt_112 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 42) (d := 112) (c := cert_42_112) (by native_decide)
