import Sound
import lean_certs.cert_42_152

open CertVerify

theorem H42_gt_152 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 42) (d := 152) (c := cert_42_152) (by native_decide)
