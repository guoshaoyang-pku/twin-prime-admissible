import Sound
import lean_certs.cert_39_86

open CertVerify

theorem H39_gt_86 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 39) (d := 86) (c := cert_39_86) (by native_decide)
