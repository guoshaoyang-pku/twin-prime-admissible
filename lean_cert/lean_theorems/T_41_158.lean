import Sound
import lean_certs.cert_41_158

open CertVerify

theorem H41_gt_158 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 41) (d := 158) (c := cert_41_158) (by native_decide)
