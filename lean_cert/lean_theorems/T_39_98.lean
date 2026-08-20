import Sound
import lean_certs.cert_39_98

open CertVerify

theorem H39_gt_98 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 39) (d := 98) (c := cert_39_98) (by native_decide)
