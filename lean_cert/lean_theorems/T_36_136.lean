import Sound
import lean_certs.cert_36_136

open CertVerify

theorem H36_gt_136 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 36) (d := 136) (c := cert_36_136) (by native_decide)
