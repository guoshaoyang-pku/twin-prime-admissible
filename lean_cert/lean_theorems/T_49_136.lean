import Sound
import lean_certs.cert_49_136

open CertVerify

theorem H49_gt_136 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 49) (d := 136) (c := cert_49_136) (by native_decide)
