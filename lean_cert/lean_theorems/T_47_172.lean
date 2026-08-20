import Sound
import lean_certs.cert_47_172

open CertVerify

theorem H47_gt_172 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 172 := by
  exact certValidRoot_sound (k := 47) (d := 172) (c := cert_47_172) (by native_decide)
