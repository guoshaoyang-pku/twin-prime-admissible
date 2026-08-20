import Sound
import lean_certs.cert_41_132

open CertVerify

theorem H41_gt_132 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 41) (d := 132) (c := cert_41_132) (by native_decide)
