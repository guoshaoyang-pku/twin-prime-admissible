import Sound
import lean_certs.cert_42_194

open CertVerify

theorem H42_gt_194 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 194 := by
  exact certValidRoot_sound (k := 42) (d := 194) (c := cert_42_194) (by native_decide)
