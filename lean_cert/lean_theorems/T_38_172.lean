import Sound
import lean_certs.cert_38_172

open CertVerify

theorem H38_gt_172 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 172 := by
  exact certValidRoot_sound (k := 38) (d := 172) (c := cert_38_172) (by native_decide)
