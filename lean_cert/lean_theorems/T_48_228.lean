import Sound
import lean_certs.cert_48_228

open CertVerify

theorem H48_gt_228 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 228 := by
  exact certValidRoot_sound (k := 48) (d := 228) (c := cert_48_228) (by native_decide)
