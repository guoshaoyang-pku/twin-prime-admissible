import Sound
import lean_certs.cert_48_98

open CertVerify

theorem H48_gt_98 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 48) (d := 98) (c := cert_48_98) (by native_decide)
