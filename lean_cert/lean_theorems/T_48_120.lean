import Sound
import lean_certs.cert_48_120

open CertVerify

theorem H48_gt_120 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 48) (d := 120) (c := cert_48_120) (by native_decide)
