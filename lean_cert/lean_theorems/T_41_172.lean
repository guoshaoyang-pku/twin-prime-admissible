import Sound
import lean_certs.cert_41_172

open CertVerify

theorem H41_gt_172 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 172 := by
  exact certValidRoot_sound (k := 41) (d := 172) (c := cert_41_172) (by native_decide)
