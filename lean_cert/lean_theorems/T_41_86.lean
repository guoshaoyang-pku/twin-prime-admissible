import Sound
import lean_certs.cert_41_86

open CertVerify

theorem H41_gt_86 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 41) (d := 86) (c := cert_41_86) (by native_decide)
