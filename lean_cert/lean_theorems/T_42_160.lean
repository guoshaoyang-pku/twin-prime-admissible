import Sound
import lean_certs.cert_42_160

open CertVerify

theorem H42_gt_160 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 160 := by
  exact certValidRoot_sound (k := 42) (d := 160) (c := cert_42_160) (by native_decide)
