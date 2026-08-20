import Sound
import lean_certs.cert_24_86

open CertVerify

theorem H24_gt_86 : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 24) (d := 86) (c := cert_24_86) (by native_decide)
