import Sound
import lean_certs.cert_49_172

open CertVerify

theorem H49_gt_172 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 172 := by
  exact certValidRoot_sound (k := 49) (d := 172) (c := cert_49_172) (by native_decide)
