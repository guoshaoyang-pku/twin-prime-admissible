import Sound
import lean_certs.cert_48_212

open CertVerify

theorem H48_gt_212 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 212 := by
  exact certValidRoot_sound (k := 48) (d := 212) (c := cert_48_212) (by native_decide)
