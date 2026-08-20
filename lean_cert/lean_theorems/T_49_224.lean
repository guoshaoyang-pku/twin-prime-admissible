import Sound
import lean_certs.cert_49_224

open CertVerify

theorem H49_gt_224 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 224 := by
  exact certValidRoot_sound (k := 49) (d := 224) (c := cert_49_224) (by native_decide)
