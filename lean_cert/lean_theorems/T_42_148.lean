import Sound
import lean_certs.cert_42_148

open CertVerify

theorem H42_gt_148 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 148 := by
  exact certValidRoot_sound (k := 42) (d := 148) (c := cert_42_148) (by native_decide)
