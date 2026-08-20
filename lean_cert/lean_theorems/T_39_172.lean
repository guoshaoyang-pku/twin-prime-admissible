import Sound
import lean_certs.cert_39_172

open CertVerify

theorem H39_gt_172 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 172 := by
  exact certValidRoot_sound (k := 39) (d := 172) (c := cert_39_172) (by native_decide)
