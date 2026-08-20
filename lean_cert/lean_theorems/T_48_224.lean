import Sound
import lean_certs.cert_48_224

open CertVerify

theorem H48_gt_224 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 224 := by
  exact certValidRoot_sound (k := 48) (d := 224) (c := cert_48_224) (by native_decide)
