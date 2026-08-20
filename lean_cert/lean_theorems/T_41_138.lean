import Sound
import lean_certs.cert_41_138

open CertVerify

theorem H41_gt_138 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 41) (d := 138) (c := cert_41_138) (by native_decide)
