import Sound
import lean_certs.cert_48_136

open CertVerify

theorem H48_gt_136 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 48) (d := 136) (c := cert_48_136) (by native_decide)
