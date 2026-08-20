import Sound
import lean_certs.cert_40_172

open CertVerify

theorem H40_gt_172 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 172 := by
  exact certValidRoot_sound (k := 40) (d := 172) (c := cert_40_172) (by native_decide)
