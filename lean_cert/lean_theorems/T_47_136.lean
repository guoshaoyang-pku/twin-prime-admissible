import Sound
import lean_certs.cert_47_136

open CertVerify

theorem H47_gt_136 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 47) (d := 136) (c := cert_47_136) (by native_decide)
