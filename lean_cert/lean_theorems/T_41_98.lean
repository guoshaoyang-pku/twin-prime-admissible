import Sound
import lean_certs.cert_41_98

open CertVerify

theorem H41_gt_98 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 41) (d := 98) (c := cert_41_98) (by native_decide)
