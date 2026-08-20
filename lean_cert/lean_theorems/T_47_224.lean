import Sound
import lean_certs.cert_47_224

open CertVerify

theorem H47_gt_224 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 224 := by
  exact certValidRoot_sound (k := 47) (d := 224) (c := cert_47_224) (by native_decide)
