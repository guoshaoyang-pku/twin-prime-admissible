import Sound
import lean_certs.cert_20_42

open CertVerify

theorem H20_gt_42 : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 42 := by
  exact certValidRoot_sound (k := 20) (d := 42) (c := cert_20_42) (by native_decide)
