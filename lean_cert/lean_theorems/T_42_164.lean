import Sound
import lean_certs.cert_42_164

open CertVerify

theorem H42_gt_164 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 164 := by
  exact certValidRoot_sound (k := 42) (d := 164) (c := cert_42_164) (by native_decide)
