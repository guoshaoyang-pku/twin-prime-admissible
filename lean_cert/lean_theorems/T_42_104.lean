import Sound
import lean_certs.cert_42_104

open CertVerify

theorem H42_gt_104 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 42) (d := 104) (c := cert_42_104) (by native_decide)
