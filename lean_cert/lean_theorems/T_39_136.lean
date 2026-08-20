import Sound
import lean_certs.cert_39_136

open CertVerify

theorem H39_gt_136 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 39) (d := 136) (c := cert_39_136) (by native_decide)
