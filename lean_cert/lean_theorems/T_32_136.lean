import Sound
import lean_certs.cert_32_136

open CertVerify

theorem H32_gt_136 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 32) (d := 136) (c := cert_32_136) (by native_decide)
