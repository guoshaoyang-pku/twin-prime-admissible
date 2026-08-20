import Sound
import lean_certs.cert_48_172

open CertVerify

theorem H48_gt_172 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 172 := by
  exact certValidRoot_sound (k := 48) (d := 172) (c := cert_48_172) (by native_decide)
